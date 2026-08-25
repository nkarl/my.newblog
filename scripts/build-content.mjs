import { readdir, readFile, writeFile } from "node:fs/promises";
import { extname, join, parse } from "node:path";
import markdown from "@wcj/markdown-to-html";
import sanitizeHtml from "sanitize-html";

const sourceDirectory = "data";
const outputFile = "dist/posts.json";
const supportedExtensions = new Set([".md", ".mdx"]);

const files = (await readdir(sourceDirectory, { withFileTypes: true }))
  .filter((entry) => entry.isFile() && supportedExtensions.has(extname(entry.name)))
  .map((entry) => entry.name)
  .sort();

const entries = await Promise.all(files.map(buildPost));
const posts = Object.fromEntries(entries.map((post) => [post.id, post]));
validateInternalPostLinks(posts);

await writeFile(outputFile, `${JSON.stringify(posts, null, 2)}\n`);
console.log(`Built ${entries.length} posts into ${outputFile}`);

async function buildPost(fileName) {
  const source = await readFile(join(sourceDirectory, fileName), "utf8");
  const { attributes, body } = parseFrontMatter(source, fileName);
  const id = parse(fileName).name.replace(/^\d{4}-\d{2}-\d{2}-/, "");
  const datePrefix = fileName.slice(0, 10);
  const createdAt = Date.parse(`${datePrefix}T00:00:00Z`);
  const preparedBody = prepareMdx(body);
  const converted = rewriteInternalLinks(markdown(preparedBody));

  return {
    id,
    title: requiredAttribute(attributes, "title", fileName),
    description: attributes.description ?? "",
    pubDate: attributes.pubDate ?? datePrefix,
    createdAt,
    type: extname(fileName).slice(1),
    content: sanitizeHtml(converted, {
      allowedTags: sanitizeHtml.defaults.allowedTags.concat(["img", "details", "summary", "kbd"]),
      allowedAttributes: {
        ...sanitizeHtml.defaults.allowedAttributes,
        "*": ["class"],
        a: ["href", "name", "target", "rel"],
        code: ["class"],
        img: ["src", "alt", "title", "width", "height", "loading"]
      },
      allowedSchemes: ["http", "https", "mailto"],
      allowProtocolRelative: false
    })
  };
}

function parseFrontMatter(source, fileName) {
  const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
  if (!match) throw new Error(`${fileName}: missing front matter`);

  const attributes = Object.fromEntries(
    match[1].split(/\r?\n/).filter(Boolean).map((line) => {
      const separator = line.indexOf(":");
      if (separator < 1) throw new Error(`${fileName}: invalid front matter line: ${line}`);
      const key = line.slice(0, separator).trim();
      const value = stripQuotes(line.slice(separator + 1).trim());
      return [key, value];
    })
  );

  return { attributes, body: source.slice(match[0].length) };
}

function prepareMdx(body) {
  return body
    .replace(/^import .*$/gm, "")
    .replace(/<div[^>]*>[\s\S]*?<img[\s\S]*?src=\{[^}]+\.src\}[\s\S]*?<\/div>/g, "");
}

function rewriteInternalLinks(html) {
  return html
    .replace(/href="\/blog\/(?:\d{4}-\d{2}-\d{2}-)?/g, 'href="#/posts/')
    .replace(/(href="#\/posts\/[^"#]+)#[^"]+"/g, '$1"')
    .replace(/href="\/(contact|resume)"/g, 'href="#/$1"');
}

function validateInternalPostLinks(posts) {
  for (const post of Object.values(posts)) {
    for (const match of post.content.matchAll(/href="#\/posts\/([^"]+)"/g)) {
      if (!posts[match[1]]) {
        throw new Error(`${post.id}: internal link points to missing post ${match[1]}`);
      }
    }
  }
}

function requiredAttribute(attributes, name, fileName) {
  const value = attributes[name];
  if (!value) throw new Error(`${fileName}: missing ${name} in front matter`);
  return value;
}

function stripQuotes(value) {
  const first = value.at(0);
  const last = value.at(-1);
  return first === last && (first === "'" || first === '"') ? value.slice(1, -1) : value;
}

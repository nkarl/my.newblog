import { cp, mkdir } from "node:fs/promises";
import remarkMath from "remark-math";

const katexSourceDirectory = "node_modules/katex/dist";
const katexOutputDirectory = "dist/vendor/katex";

export const renderTex = {
  remarkPlugins: [remarkMath],
  katexOptions: {
    throwOnError: false,
    strict: "warn",
    trust: false
  }
};

export async function prepareTexAssets() {
  await mkdir(katexOutputDirectory, { recursive: true });
  await cp(`${katexSourceDirectory}/katex.min.css`, `${katexOutputDirectory}/katex.min.css`);
  await cp(`${katexSourceDirectory}/fonts`, `${katexOutputDirectory}/fonts`, { recursive: true });
}

export function validateTexOutput(posts) {
  let expressions = 0;

  for (const post of Object.values(posts)) {
    if (post.content.includes("katex-error")) {
      throw new Error(`${post.id}: KaTeX could not render one or more expressions`);
    }
    expressions += post.content.match(/class="katex"/g)?.length ?? 0;
  }

  return expressions;
}

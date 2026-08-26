import rehypeSanitize, { defaultSchema } from "rehype-sanitize";

const safeClassName = /^[A-Za-z0-9_-]+$/;

const contentSchema = {
  ...defaultSchema,
  tagNames: [...defaultSchema.tagNames, "details", "summary", "kbd"],
  attributes: {
    ...defaultSchema.attributes,
    code: [...(defaultSchema.attributes.code || []), ["className", safeClassName]],
    div: [
      ...(defaultSchema.attributes.div || []),
      ["className", "math", "math-display", safeClassName]
    ],
    span: [
      ...(defaultSchema.attributes.span || []),
      ["className", "math", "math-inline", safeClassName]
    ]
  }
};

// Run before trusted renderers so authored HTML is constrained without
// stripping renderer-generated output such as KaTeX's accessible MathML.
export const sanitizeContent = [rehypeSanitize, contentSchema];

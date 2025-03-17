import '@wcj/markdown-to-html';

function transformMarkdownImpl(input) {
  var content = (async () => {
    return await transformer(input);
  })();

  return function() {
    return content;
  };
}

export {
  transformMarkdownImpl
}

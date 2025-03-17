import markdown from '@wcj/markdown-to-html';

function convertMarkdownImpl(input) {
  var content = (async () => {
    return markdown(input);
  })();

  return function() {
    return content;
  };
}

export {
  convertMarkdownImpl
}

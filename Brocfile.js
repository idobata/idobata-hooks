var pickFiles       = require('broccoli-static-compiler');
var renderTemplates = require('broccoli-render-template');
var renameFiles     = require('broccoli-rename-files');
var mergeTrees      = require('broccoli-merge-trees');

var templates = pickFiles('lib/hooks', {
  srcDir:  '/',
  files:   ['*/help.html.haml'],
  destDir: 'templates/idobata-hooks'
});

templates = renderTemplates(templates);
templates = renameFiles(templates, {
  transformFilename: function(filename, basename, extname) {
    return basename.replace('.html', '.hbs');
  }
});

var styles = pickFiles('lib/hooks', {
  srcDir: '/',
  files:  ['*/style.sass'],
  destDir: 'styles/idobata-hooks'
});

module.exports = mergeTrees([templates, styles]);

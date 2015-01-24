var haml            = require('hamljs');
var pickFiles       = require('broccoli-static-compiler');
var renderTemplates = require('broccoli-render-template');
var renameFiles     = require('broccoli-rename-files');

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

module.exports = renderTemplates(templates);

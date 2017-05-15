const Filter     = require('broccoli-filter');
const Funnel     = require('broccoli-funnel');
const concat     = require('broccoli-concat');
const haml       = require('hamljs');
const mergeTrees = require('broccoli-merge-trees');

class RenderHaml extends Filter {
  processString(content) {
    return haml.render(content).trimLeft();
  }

  getDestFilePath(relativePath) {
    return `templates/idobata-hooks/${relativePath.replace(/\.html\.haml$/, '.hbs')}`;
  }
}

const styles = concat('lib/hooks', {
  inputFiles: ['*/style.sass'],
  outputFile: '/styles/_idobata-hooks.sass'
});

const templates = new Funnel('lib/hooks', {
  include: ['*/help.html.haml']
});

const helps = new RenderHaml(templates);

module.exports = mergeTrees([styles, helps]);

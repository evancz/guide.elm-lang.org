
module.exports = {
    website: {
        assets: "./assets",
        js: ["repl.js"]
    },
    blocks: {
        repl: {
            process: function(block) {
                return '<div class="elm-repl">' + escapeText(block.body) + "</div>";
            }
        }
        replWithTypes: {
            process: function(block) {
                return '<div class="elm-repl show-types">' + escapeText(block.body) + "</div>";
            }
        }
    }
};




function escapeText(text)
{
  return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
}

const { watch, readFileSync, writeFileSync } = require("node:fs");

const stylesPath = "./public/index.css";
const templatePath = "../src/Template/W/Styles.elm";
const destinationPath = "../src/W/Styles.elm";

function generateStylesModule() {
  const styles = readFileSync(stylesPath, "utf8").replace(/\\(?!\\)/g, "\\\\")

  const template =
    readFileSync(templatePath, "utf8")
      .replace("module Template.", "module ")
      .replace("<| Debug.todo \"STYLES\"", `"""${styles}"""`)

  writeFileSync(destinationPath, template);
}

generateStylesModule();
watch(stylesPath, generateStylesModule);


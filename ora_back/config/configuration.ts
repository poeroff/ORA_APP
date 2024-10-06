import { readFileSync } from 'fs';
import * as yaml from 'js-yaml';
import { join } from 'path';

const DEPLOY_MAIN_YAML_PATH = join(__dirname, '..', '..', '.github', 'workflows', 'deploy-main.yml');
const ORA_APP_YAML_PATH = join(__dirname, '..', 'ora_back', 'ora-app.yaml');

export default () => {
  const loadYamlFile = (filePath: string) => {
    try {
      return yaml.load(
        readFileSync(filePath, 'utf8'),
      ) as Record<string, any>;
    } catch (error) {
      console.error(`Error loading ${filePath}: ${error.message}`);
      return null;
    }
  };

  const deployMainYaml = loadYamlFile(DEPLOY_MAIN_YAML_PATH);
  const oraAppYaml = loadYamlFile(ORA_APP_YAML_PATH);

  return {
    deployMain: deployMainYaml,
    oraApp: oraAppYaml
  };
};
export default {
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: "tsconfig.json",
    sourceType: "module",
    ecmaVersion: 2020,
  },
  plugins: ["@typescript-eslint/eslint-plugin", "import", "prettier", "node", "security"],
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "plugin:node/recommended",
    "plugin:security/recommended",
    "plugin:prettier/recommended",
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: [".eslintrc.js", "dist", "node_modules"],
  rules: {
    // TypeScript specific rules
    "@typescript-eslint/interface-name-prefix": "off",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/explicit-module-boundary-types": "warn",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/no-unused-vars": [
      "error",
      {
        argsIgnorePattern: "^_",
        varsIgnorePattern: "^_",
      },
    ],

    // Node.js specific rules
    "node/no-missing-import": "off", // TypeScript handles this
    "node/no-unsupported-features/es-syntax": "off", // TypeScript handles this
    "node/no-missing-require": "off", // TypeScript handles this

    // Import rules
    "import/order": [
      "error",
      {
        groups: ["builtin", "external", "internal", "parent", "sibling", "index"],
        "newlines-between": "always",
        alphabetize: {order: "asc", caseInsensitive: true},
      },
    ],
    "import/no-unresolved": "off", // TypeScript handles this

    // General JavaScript rules
    "no-console": ["warn", {allow: ["warn", "error"]}],
    "no-return-await": "error",
    "require-await": "error",
    "no-throw-literal": "error",
    "no-unused-expressions": "error",
    "no-var": "error",
    "prefer-const": "error",
    "prefer-template": "error",
    eqeqeq: ["error", "always"],

    // Security rules
    "security/detect-object-injection": "off", // Often too strict
    "security/detect-non-literal-fs-filename": "warn",

    // Error handling
    "handle-callback-err": "error",
    "no-promise-executor-return": "error",
    "max-nested-callbacks": ["error", 3],
  },
  settings: {
    "import/resolver": {
      typescript: {},
      node: {
        extensions: [".js", ".jsx", ".ts", ".tsx"],
      },
    },
  },
}

module.exports = {
  client: {
    includes: ['./Swifters/**/*.graphql'],
    service: {
      name: "github",
      localSchemaFile: "./Swifters/schema.json"
    }
  }
}

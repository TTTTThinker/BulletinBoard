module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "172.17.0.2",
      port: 8545,
      network_id: "*" // Match any network id
    },
    develop: {
      port: 8545
    }
  }
};

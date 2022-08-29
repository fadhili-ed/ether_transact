# Ethertransact

### Setup Instructions

Befor running the project on your local environment;
  * Create an account on [Etherscan](https://etherscan.io/) and generate an API key from your account.
  * Create a `.env` file inside your project folder and add the `etherscan api key` that was generated in the step above.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Overview of Apps functionality

  * The application allows a user to input a hash code on the dashboard which is then used to query transaction details using the [eth_getTransactionByHash](https://docs.etherscan.io/api-endpoints/geth-parity-proxy#eth_gettransactionbyhash) giving a valid response according to the situation. For example, in case of a new hash, the transaction details will be fetched and displayed and a success message will be displayed. However, a hash that already exists in the database will bring an error ***Transaction has already been entered!*** since it has been set to be a unique constraint in the database.
  * Once a transaction is made, this is marked as payment being receieved. Confirmation of payment is done by implementing a Genserver which performs the following:
    * It keeps track of the most recent block number by calling the [eth_blockNumber](https://docs.etherscan.io/api-endpoints/geth-parity-proxy#eth_blocknumber) endpoint.
    * In case of no errors, it proceeds to make a check if there are any pending transactions i.e *if there are any records in the database with the `complete` field set to `false`*. If none, the Genserver terminates. If any then it proceeds to the next step.
    * The next step is to call the current block number in order to get the state, then it confirms the payments that have more than two block confirmations by changing the `complete` field to `true`, this runs after every 10 seconds.
    * The Genserver then rechecks if there are any pending payments and if not it terminates.
    * The Genserver is restarted every time a new hash is added and it performs the above functions.
  * The application uses liveview and the page has been set to change the value of the row *status* on the dashboard to **Transaction Complete** after the update from the Genserver has been made. This was achieved by making a broadcast each time the Genserver performs an update, the index page is subscribed onto the same topic broadcasted and thus updating the page with the new updated data.
  * Tests use [ExVCR](https://github.com/parroty/exvcr) with `Hackney` to tests the responses from the endpoints while fetching the `block_number`, a valid `tx_hash` and an invalid `tx_hash`, this response is recorded in vcr_cassettes.


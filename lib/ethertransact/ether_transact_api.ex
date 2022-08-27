defmodule Ethertransact.EtherTransactApi do
  @base_url "https://api.etherscan.io/api?"
  @api_key Application.fetch_env!(:ethertransact, :etherscan_api_key)
  @headers [Accept: "Application/json"]

  def fetch_transaction_by_hash(tx_hash) do
    tx_hash
    |> get_transaction_by_hash()
    |> HTTPoison.get(@headers)
    |> handle_response()
  end

  def fetch_most_recent_block_number do
    most_recent_block_number()
    |> HTTPoison.get(@headers)
    |> handle_response()
  end

  defp most_recent_block_number() do
    "#{@base_url}module=proxy&action=eth_blockNumber&apikey=#{@api_key}"
  end

  defp get_transaction_by_hash(tx_hash) do
    "#{@base_url}module=proxy&action=eth_getTransactionByHash&txhash=#{tx_hash}&apikey=#{@api_key}"
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body, status_code: status_code}})
       when status_code in 200..399 do
    case Jason.decode(body) do
      {:ok, %{"result" => result, "id" => _id}} -> {:ok, result}
      {_, result} -> {:error, result}
    end
  end

  defp handle_response({_, response}) do
    {:error, response}
  end
end

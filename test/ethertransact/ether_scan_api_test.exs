defmodule Ethertransact.EtherScanApiTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
    :ok
  end

  test "fetch a valid hash" do
    use_cassette "request_transaction" do
      assert {:ok, _results} =
        Ethertransact.EtherTransactApi.fetch_transaction_by_hash(
                 "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
               )
    end
  end

  test "fetch an invalid hash" do
    use_cassette "request_invalid_transaction" do
      assert {:error, _results} = Ethertransact.EtherTransactApi.fetch_transaction_by_hash("invalid")
    end
  end

  test "fetch most recent block_number" do
    use_cassette "request_block_number" do
      assert {:ok, _results} = Ethertransact.EtherTransactApi.fetch_most_recent_block_number()
    end
  end
end

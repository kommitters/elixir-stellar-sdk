defmodule Stellar.Network.Transactions.Test do
  use Stellar.HttpCase
  alias Stellar.Network.Transactions

  test "get transaction details", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/transactions/123456", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": "123456"}>)
    end)

    assert {:ok, %{"id" => "123456"}} = Transactions.get("123456")
  end

  test "get all transactions", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/transactions", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Transactions.all()
  end

  test "get all transactions for an account", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/accounts/123456/transactions", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Transactions.all_for_account("123456")
  end

  test "get all transactions for a ledger", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/ledgers/123456/transactions", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Transactions.all_for_ledger("123456")
  end

  test "post a transaction", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/transactions", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"hash": ""}>)
    end)

    assert {:ok, %{"hash" => _}} = Transactions.post("my_xdr_envelope")
  end
end

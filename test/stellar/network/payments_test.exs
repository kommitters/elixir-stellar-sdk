defmodule Stellar.Network.Payments.Test do
  use Stellar.HttpCase
  alias Stellar.Network.Payments

  test "get all payments", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/payments", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Payments.all()
  end

  test "get all payments for an account", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/accounts/123456/payments", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Payments.all_for_account("123456")
  end

  test "get all payments for a ledger", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/ledgers/123456/payments", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"_embedded": { "records": [] }}>)
    end)

    assert {:ok, %{"_embedded" => _}} = Payments.all_for_ledger("123456")
  end
end

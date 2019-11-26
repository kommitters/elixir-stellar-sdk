defmodule TestStellar do
  alias Stellar.Base.{TransactionBuilder, Transaction, Operation, Account, KeyPair}
  alias Stellar.XDR.Types.Transaction.TransactionEnvelope
  alias Stellar.Network.Transactions

  def testAllow do
    source =
      Account.new("GAYIVSXCNALI3D7P5ROBJ7Q6I4QN6APVRU7CONUP7U6IKJJRPGKYM4EY", 321130409754627)

    signer = KeyPair.from_secret("SDHPVJCQEFM5CJ4NDZYGZYOG3DXV35QHR5IQO3VR3BT2YTS2U3DZCJMB")

    trustor = "GDDVWKPMJKUH766SMOVKLDTZQCC4B7Q42YRRH7YBBDYDFPI7LWKJP55F"
    asset_code = "DCH"
    authorize = true
    issuer = "GAYIVSXCNALI3D7P5ROBJ7Q6I4QN6APVRU7CONUP7U6IKJJRPGKYM4EY"

    {:ok, transaction, _} =
      TransactionBuilder.new(source, [{:fee, 100}])
      |> TransactionBuilder.add_operation(
        Operation.allow_trust(%{
          trustor: trustor,
          asset_code: asset_code,
          authorize: authorize,
          issuer: issuer
        })
      )
      |> TransactionBuilder.set_timeout(10)
      |> TransactionBuilder.build()

    signed_transaction =
      transaction
      |> Transaction.sign(signer)

    env = signed_transaction |> Transaction.to_envelope()

    with {:ok, xdr_envelope} <- env |> TransactionEnvelope.encode()|> IO.inspect(),
         base64_envelope <- xdr_envelope |> Base.encode64(),
         {status, result} <- Transactions.post(base64_envelope) do
      {status, result}
    end
  end

  def setOption do
    source =
      Account.new("GDRSG4KRN6SFM3C7NFRVB5Y3PR6OFEBY4TOP4EHLAAMZXRAWJMRBO4VE", 29_888_677_412_949)

    signer = KeyPair.from_secret("SDHPVJCQEFM5CJ4NDZYGZYOG3DXV35QHR5IQO3VR3BT2YTS2U3DZCJMB")

    {:ok, transaction, _} =
      TransactionBuilder.new(source, [{:fee, 100}])
      |> TransactionBuilder.add_operation(
        Operation.set_options(%{
          maste_weight: 3
        })
      )
      |> TransactionBuilder.set_timeout(10)
      |> TransactionBuilder.build()

    signed_transaction =
      transaction
      |> Transaction.sign(signer)

    env = signed_transaction |> Transaction.to_envelope()

    with {:ok, xdr_envelope} <- env |> TransactionEnvelope.encode(),
         base64_envelope <- xdr_envelope |> Base.encode64(),
         {status, result} <- Transactions.post(base64_envelope) do
      {status, result}
    end
  end
end

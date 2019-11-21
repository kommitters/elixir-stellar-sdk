defmodule TestStellar do
  alias Stellar.Base.{TransactionBuilder, Transaction, Operation, Account, KeyPair, Signer}
  alias Stellar.XDR.Types.Transaction.TransactionEnvelope
  alias Stellar.Network.Transactions

  def test do
    source =
      Account.new("GDRSG4KRN6SFM3C7NFRVB5Y3PR6OFEBY4TOP4EHLAAMZXRAWJMRBO4VE", 29888677412946)

    signer = KeyPair.from_secret("SDHPVJCQEFM5CJ4NDZYGZYOG3DXV35QHR5IQO3VR3BT2YTS2U3DZCJMB")

    signer_to_add =
      Signer.new(%{
        type: :ed25519,
        public_key: "GDDVWKPMJKUH766SMOVKLDTZQCC4B7Q42YRRH7YBBDYDFPI7LWKJP55F",
        weight: 1
      })

    {:ok, transaction, _} =
      TransactionBuilder.new(source, [{:fee, 100}])
      |> TransactionBuilder.add_operation(
        Operation.set_options(%{
          master_weight: 3
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

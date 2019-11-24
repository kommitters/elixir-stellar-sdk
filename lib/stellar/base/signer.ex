defmodule Stellar.Base.Signer do
  @type key :: binary
  @type signature :: binary

  alias Stellar.XDR.Types.LedgerEntries.{Signer}
  alias Stellar.XDR.Types.{SignerKey, UInt32}
  alias Stellar.Base.{KeyPair, StrKey}

  def to_xdr(%{key: key, weight: weight}) do
    with {:ok, signer_account} <- KeyPair.from_public_key(key) |> to_xdr_accountid(),
         {:ok, signer_weight} <- amount_to_xdr(weight) do
      %Signer{key: signer_account, weight: signer_weight}
    end
  end

  def from_xdr(signer) do
    %{key: account_id_to_address(signer.key), weight: signer.weight}
  end

  defp account_id_to_address({:SIGNER_KEY_TYPE_ED25519, signer_account}) do
    signer_account |> StrKey.encode_ed25519_public_key()
  end

  defp to_xdr_accountid(this) do
    SignerKey.new({:SIGNER_KEY_TYPE_ED25519, this._public_key})
  end

  defp amount_to_xdr(this) do
    UInt32.new(this)
  end

  @spec sign(binary(), Ed25519.key()) :: signature()
  def sign(data, secret) do
    Ed25519.signature(data, secret)
  end

  @spec verify(binary, signature(), Ed25519.key()) :: boolean
  def verify(data, signature, public_key) do
    Ed25519.valid_signature?(signature, data, public_key)
  end
end

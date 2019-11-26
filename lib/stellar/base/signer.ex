defmodule Stellar.Base.Signer do
  @type key :: binary
  @type signature :: binary

  alias Stellar.XDR.Types.LedgerEntries.{Signer}
  alias Stellar.XDR.Types.{SignerKey, UInt32}
  alias Stellar.Base.{KeyPair, StrKey}

  @spec to_xdr(nil) :: nil
  def to_xdr(nil), do: nil

  @spec to_xdr(weigth :: number()) :: {:error, :invalid_weight}
  def to_xdr(%{key: _, weight: weight}) when weight > 255, do: {:error, :invalid_weight}

  @doc """
  This function is in charge to convert the signer to XDR
    ##Parameters
    - key: is the public key of the signer wanted to add to the new account
    - weight: represents the weight of the signer to add
  returns a signer on XDR format
  """
  @spec to_xdr(map()) :: Signer.t()
  def to_xdr(%{key: key, weight: weight}) do
    with {:ok, signer_account} <- KeyPair.from_public_key(key) |> to_xdr_accountid(),
         {:ok, signer_weight} <- amount_to_xdr(weight) do
      %Signer{key: signer_account, weight: signer_weight}
    end
  end

  @spec from_xdr(nil) :: nil
  def from_xdr(nil), do: nil

  @doc """
  This function takes the Signer struct and decode from XDR
    ##Parameters
    - signer: represents a map with the XDR info about the signer
  Returns a map of the signer data on default type
  """
  @spec from_xdr(signer :: Signer.t()) :: map()
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

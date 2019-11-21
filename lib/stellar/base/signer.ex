defmodule Stellar.Base.Signer do
  @type key :: binary
  @type signature :: binary

  defstruct type: nil, weight: nil, _public_key: nil

  def new(%{type: :ed25519, public_key: public_key}) when byte_size(public_key) !== 56,
    do: {:error, "invalid public key"}

  def new(%{type: :ed25519, public_key: public_key, weight: weight}) do
    %__MODULE__{
      type: :ed25519,
      _public_key: public_key,
      weight: weight
    }
  end

  def new(_), do: {:error, "invalid keys type"}

  @spec sign(binary(), Ed25519.key()) :: signature()
  def sign(data, secret) do
    Ed25519.signature(data, secret)
  end

  @spec verify(binary, signature(), Ed25519.key()) :: boolean
  def verify(data, signature, public_key) do
    Ed25519.valid_signature?(signature, data, public_key)
  end
end

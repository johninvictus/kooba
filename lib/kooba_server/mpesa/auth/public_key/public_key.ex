defmodule KoobaServer.Mpesa.Auth.PublicKey do
  require KoobaServer.Mpesa.Auth.PublicKey.Record
  alias KoobaServer.Mpesa.Auth.PublicKey.Record

  @cert_path "./lib/kooba_server/mpesa/auth/certificate/cert.cer"

  def extract_public_from(certfile \\ @cert_path) do
    cert_text =
      File.read!(certfile)
      |> String.trim()

    [pem_entry] = :public_key.pem_decode(cert_text)
    cert_decoded = :public_key.pem_entry_decode(pem_entry)

    plk_der =
      cert_decoded
      |> Record."Certificate"(:tbsCertificate)
      |> Record."TBSCertificate"(:subjectPublicKeyInfo)
      |> Record."SubjectPublicKeyInfo"(:subjectPublicKey)

    :public_key.der_decode(:RSAPublicKey, plk_der)
  end

  def generate_base64_cypherstring(public_key, plain_text) when is_tuple(public_key) do
    plain_text
    |> :public_key.encrypt_public(public_key, [{:rsa_pad, :rsa_pkcs1_padding}])
    |> :base64.encode()
  end
end

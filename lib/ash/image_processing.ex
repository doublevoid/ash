defmodule Ash.ImageProcessing do
  use Rustler, otp_app: :ash, crate: "image_processing"

  # When your NIF is loaded, it will override this function.
  def convert_to_grayscale(_binary), do: :erlang.nif_error(:nif_not_loaded)
end

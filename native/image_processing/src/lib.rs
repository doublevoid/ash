use rustler::{Binary, Env, NifResult, OwnedBinary};
use std::io::{BufWriter, Cursor};

#[rustler::nif(schedule = "DirtyCpu")]
fn convert_to_grayscale<'a>(env: Env<'a>, binary: Binary<'a>) -> NifResult<Binary<'a>> {
    let image = image::load_from_memory(binary.as_slice()).unwrap();
    let grayscale_image = image.grayscale();

    let mut output_buffer = Vec::new();

    grayscale_image
        .write_to(
            &mut BufWriter::new(&mut Cursor::new(&mut output_buffer)),
            image::ImageFormat::Png,
        )
        .unwrap();

    let mut owned_binary = OwnedBinary::new(output_buffer.len()).unwrap();
    owned_binary.copy_from_slice(&output_buffer);

    Ok(Binary::from_owned(owned_binary, env))
}

rustler::init!("Elixir.Ash.ImageProcessing");

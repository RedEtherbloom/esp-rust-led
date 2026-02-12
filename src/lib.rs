#![no_std]

use nom::{
    Err, IResult, Needed, bytes::{self, streaming::tag}, character,
    error::{Error, ErrorKind},
};

enum TPM2PacketType {
    ResponseRequested = 0xAA,
    Command = 0xC0,
    Data = 0xDA,
    Unknown,
}

const TPM2_PACKET_START_BYTE: u8 = 0xC9;
const TPM2_NET_PACKET_START_BYTE: u8 = 0x9C;
const TPM2_PACKET_END_BYTE: u8 = 0x36;

#[derive(Debug, PartialEq)]
struct RGBColor {
    red: u8,
    green: u8,
    blue: u8,
}

fn parse_tpm2_color(input: &[u8]) -> IResult<&[u8], RGBColor> {
    let (remaining, color) = bytes::streaming::take(3u8)(input)?;
    Ok((
        remaining,
        RGBColor {
            red: *color.get(0).unwrap(),
            green: *color.get(1).unwrap(),
            blue: *color.get(2).unwrap(),
        },
    ))
}

// TODO: This should produce an iterator if possible, to avoid as much heap alloc as possible
fn parse_tpm2_packet(input: &[u8]) -> IResult<&[u8], impl Iterator<Item = RGBColor>> {
  tag(TPM2_PACKET_START_BYTE)?;

  
}

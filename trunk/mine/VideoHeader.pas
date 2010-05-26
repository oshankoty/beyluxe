unit VideoHeader;

interface

const
  //VIDEODLL = 'F:\Works\Public\Intel IPP\ipp-samples\audio-video-codecs\application\HCVideo\Debug\HCVideo.dll';
  VIDEODLL = 'HCVideo.dll';

  function InitCompressor(ImageWidth,ImageHeight: Integer): Pointer;  stdcall; external VIDEODLL name 'InitCompressor';
  procedure UnInitCompressor(Handle: Pointer); stdcall external VIDEODLL name 'UnInitCompressor';
  function EncodeFrameSet(Handle: Pointer; InBuf,OutBuf: Pointer; InBufSize: Integer;var OutBufSize: Integer; IFrame: Boolean): Integer;  stdcall; external VIDEODLL name 'EncodeFrameSet';
  function InitDeCompressor(ImageWidth,ImageHeight: Integer): Pointer;  stdcall; external VIDEODLL name 'InitDeCompressor';
  procedure UnInitDeCompressor(Handle: Pointer); stdcall external VIDEODLL name 'UnInitDeCompressor';
  function DecodeFrameSet(Handle: Pointer; InBuf,OutBuf: Pointer; InBufSize: Integer;var OutBufSize: Integer): Integer;  stdcall; external VIDEODLL name 'DecodeFrameSet';


implementation

end.
 
ffmpeg -f oss -i /dev/dsp -acodec libmp3lame -ab 32k -ac 1 -re -f rtp rtp://234.5.5.5:1234


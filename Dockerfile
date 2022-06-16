# pedbap/libjasper-fuzz
FROM fuzzers/libfuzzer:12.0

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev 
RUN git clone https://github.com/jasper-software/jasper.git
WORKDIR /jasper
RUN cmake -DALLOW_IN_SOURCE_BUILD=true .
RUN make
RUN make install
RUN cp ./src/app/fuzz.c .
RUN clang -I/jasper/src/libjasper/include/ -L/jasper/src/libjasper -g -O1 -fsanitize=fuzzer,address fuzz.c -o /jasperFuzz -ljasper
ENV LD_LIBRARY_PATH=/jasper/src/libjasper/

ENTRYPOINT []
CMD /jasperFuzz

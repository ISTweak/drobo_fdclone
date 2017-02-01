### NCURSES ###
_build_ncurses() {
local VERSION="6.0"
local FOLDER="ncurses-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="https://ftp.gnu.org/gnu/ncurses/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"

./configure --host="${HOST}" --prefix="${DEST}" 
make
make install
popd
}


### FDCLONE ###
_build_fdclone() {
local VERSION="3.01b"
local FOLDER="FD-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://hp.vector.co.jp/authors/VA012337/soft/fd/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
sed -i -e 's|__INSTSTRIP__|-m 0755|g' Makefile.in
sed -i -e 's|$(CHMOD) a+rx $(BINDIR)/$(PROGRAM)$(EXE)|${TOOLCHAIN}/bin/${HOST}-strip $(BINDIR)/$(PROGRAM)$(EXE)|g' Makefile.in

make PREFIX="${DEST}" CONFDIR="${DEST}/etc" HOSTCC=gcc HOST=arm-none-linux-gnueabi  CC="${TOOLCHAIN}/bin/${HOST}-gcc" LDFLAGS="${LDFLAGS:-} -L${DEPS}/lib"
make install
popd
}

### BUILD ###
_build() {
  _build_ncurses
  _build_fdclone
  _package
}


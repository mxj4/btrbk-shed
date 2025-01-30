
# Dev dependencies:
## cpanm, curl, shasums
# Runtime dependencies:
## systemd, btrfs, glib, rsync, diff, (rpm-ostree)

pushd btrbk-shed

# install btrbk
pushd usr/bin
curl -L -o ./btrbk-shed-btrbk https://github.com/digint/btrbk/raw/refs/tags/v0.32.6/btrbk
chmod +x .//btrbk-shed-btrbk
echo "c8644931cc17ab6d30aa71a7613fe2bbaf6ce0756cc3062a57605b3ab4fcd877 btrbk-shed-btrbk" \
  | sha256sum -c
popd

# install File::Rsync
pushd usr/share/btrbk-shed
cpanm --pureperl --no-man-pages --notest --local-lib-contained . File::Rsync
rm -rf ./lib/perl5/x86_64-linux-thread-multi
mv ./lib/perl5 ./vendor_perl
rmdir ./lib
popd

popd

# call a command and send it to background
background()
{
    "$@" &
}

# easy sshfs mounting, courtesy of t3o (http://t4b.taponet.de/blog/)
function moxpoints
{
   reply=(`grep 'Host ' ~/.ssh/config | awk '{print $2}'`)
}

function mox()
{
   MOUNTPOINT="$HOME/ext/$1"
   if [ ! -d "$MOUNTPOINT" ]; then
      mkdir "$MOUNTPOINT"
   fi
   sshfs "$1:" "$MOUNTPOINT"
   cd "$MOUNTPOINT"
}

function umoxpoints
{
    reply=(`mount | grep '/home/seth/ext'| awk -F: '{print $1}'`)
}

function umox()
{
   MOUNTPOINT="$HOME/ext/$1"
   fusermount -u "$MOUNTPOINT"
}

compctl -K moxpoints mox
compctl -K moxpoints umox

# multimedia
function dvd() {mplayer dvd://$* -dvd-device /dev/sr0}
function fbmplayer() {mplayer -vo fbdev2 -xy 1920 -zoom -fs $*}

# pwsafe
function pwa() {pwsafe -a $1}
function pwp() {pwsafe -p $1}
function pwu() {pwsafe -u $1}
function pwl() {pwsafe -l $1 | sed 'N;s/\n/ /' | column -t -s $'>'}
function pwlnr() {pwsafe -l $1 | sed 'N;s/\n/ /' | column -t -s $'>' | nl}
function pwlpr() {pwsafe -l $1 | sed 'N;s/\n/ /' | column -t -s $'>' | nl | pr}

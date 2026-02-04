#!/data/data/com.termux/files/usr/bin/bash
# 🔥 ARYAN AFRIDI — All Host + Auto Setup (by Boss)

# 🎨 Colors
R='\033[1;31m'; G='\033[1;32m'; Y='\033[1;33m'; B='\033[1;34m'; P='\033[1;35m'; C='\033[1;36m'; W='\033[1;37m'; RS='\033[0m'
LOG="/data/data/com.termux/files/home/.host_log.txt"

# 🧹 Clean old log
[ -f "$LOG" ] && rm -f "$LOG"

# 🚫 Trap exit
trap 'pkill -f "php -S" >/dev/null 2>&1; pkill -f "cloudflared" >/dev/null 2>&1; pkill -f "tmole" >/dev/null 2>&1; exit' INT

# 🖼️ Centered Stylish Banner
banner() {
  clear
  echo -e "\n${C}============================================================${RS}\n"
  echo -e "${G}  ██████╗  ██████╗ ████████╗██╗      ██╗  ██╗ ██████╗ ███████╗████████╗ ${RS}"
  echo -e "${B}  ██╔══██╗██╔════╝ ╚══██╔══╝██║      ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝ ${RS}"
  echo -e "${C}  ██║  ██║██║  ███╗   ██║   ██║      ███████║██║   ██║███████╗   ██║    ${RS}"
  echo -e "${Y}  ██║  ██║██║   ██║   ██║   ██║      ██╔══██║██║   ██║╚════██║   ██║    ${RS}"
  echo -e "${R}  ██████╔╝╚██████╔╝   ██║   ███████╗ ██║  ██║╚██████╔╝███████║   ██║    ${RS}"
  echo -e "${W}  ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝    ${RS}\n"
  echo -e "${C}            >>> DIGITAL HOSTING INTERFACE <<<${RS}"
  echo -e "${Y}         Created By ${G}[ ${C}ARYAN AFRIDI ${G}]${RS}\n"
  echo -e "${C}============================================================${RS}"
  echo -e "${G}   ✦ Host UI ✦ Server Setup ✦ Secure & Fast ✦${RS}"
  echo -e "${C}============================================================${RS}\n"
}
# 🧩 Package Check + Install
install_pkg() {
  pkg_name=$1; cmd_name=$2; desc=$3
  echo -e "${Y}🔍 Checking ${C}${pkg_name}${Y} (${desc})...${RS}"
  if command -v "$cmd_name" >/dev/null 2>&1; then
    echo -e "${G}✅ Already Installed:${W} ${pkg_name}${RS}\n"
  else
    echo -e "${B}📦 Installing:${W} ${pkg_name}${RS}"
    pkg install -y "$pkg_name" >/dev/null 2>&1
    if command -v "$cmd_name" >/dev/null 2>&1; then
      echo -e "${G}✅ Successfully Installed:${W} ${pkg_name}${RS}\n"
    else
      echo -e "${R}❌ Failed to install:${W} ${pkg_name}${RS}\n"
    fi
  fi
}

auto_setup() {
  banner
  echo -e "${C}▶ Checking & Installing Requirements...${RS}\n"
  pkg update -y >/dev/null 2>&1
  pkg upgrade -y >/dev/null 2>&1
  install_pkg "php" "php" "PHP Server"
  install_pkg "python" "python" "Python Interpreter"
  install_pkg "nodejs" "node" "NodeJS Runtime"
  install_pkg "npm" "npm" "Node Package Manager"
  install_pkg "openssh" "ssh" "SSH Client"
  install_pkg "cloudflared" "cloudflared" "Cloudflare Tunnel"
  
  # Tunnelmole
  echo -e "${Y}🔍 Checking Tunnelmole (npm)...${RS}"
  if command -v tmole >/dev/null 2>&1; then
    echo -e "${G}✅ Already Installed:${W} Tunnelmole${RS}\n"
  else
    echo -e "${B}📦 Installing:${W} Tunnelmole${RS}"
    npm install -g tunnelmole >/dev/null 2>&1
    command -v tmole >/dev/null 2>&1 && echo -e "${G}✅ Tunnelmole Installed${RS}\n" || echo -e "${R}❌ Tunnelmole install failed${RS}\n"
  fi
}

# 🌍 Utilities
getlink() { grep -oE 'https?://[^ ]+' "$LOG" | head -n1; }

# 🗂️ File Path
get_path() {
  read -p $'\e[1;33mEnter File Path [default: current]: \e[0m' path
  path=${path:-$(pwd)}
  [[ ! -d "$path" ]] && mkdir -p "$path"
  echo "$path"
}

# 🌐 Servers
php_local() {
  path=$(get_path)
  read -p $'\e[1;33mEnter Port [default:8080]: \e[0m' port; port=${port:-8080}
  php -S 127.0.0.1:$port -t "$path" >/dev/null 2>&1 &
  echo -e "${G}▶ Hosted at:${Y} http://127.0.0.1:$port${RS}"
}

python_local() {
  path=$(get_path)
  read -p $'\e[1;33mEnter Port [default:8080]: \e[0m' port; port=${port:-8080}
  cd "$path" && python3 -m http.server $port >/dev/null 2>&1 &
  echo -e "${G}▶ Hosted at:${Y} http://127.0.0.1:$port${RS}"
}

cloudflared_tunnel() {
  path=$(get_path)
  read -p $'\e[1;33mEnter Port [default:8080]: \e[0m' port; port=${port:-8080}
  php -S 127.0.0.1:$port -t "$path" >/dev/null 2>&1 &
  cloudflared tunnel --url http://127.0.0.1:$port --logfile "$LOG" >/dev/null 2>&1 &
  sleep 6
  cldflr=$(grep -oE 'https://[-0-9a-z]*\.trycloudflare.com' "$LOG" | head -1)
  if [[ -n "$cldflr" ]]; then
    echo -e "${G}🔗 Cloudflared Link:${Y} $cldflr${RS}"
  else
    echo -e "${R}❌ Failed to get Cloudflared link.${RS}"
    tail -n 10 "$LOG"
  fi
  echo -e "${C}\nPress Ctrl+C to stop server...${RS}"
  while true; do sleep 1; done
}

serveo_tunnel() {
  path=$(get_path)
  read -p $'\e[1;33mEnter Port [default:8080]: \e[0m' port; port=${port:-8080}
  php -S 127.0.0.1:$port -t "$path" >/dev/null 2>&1 &
  ssh -o StrictHostKeyChecking=no -R 80:localhost:$port serveo.net >"$LOG" 2>&1 &
  sleep 6
  L=$(getlink)
  [[ -n "$L" ]] && echo -e "${G}🔗 Serveo:${Y} $L${RS}" || echo -e "${R}❌ Failed to get Serveo link${RS}"
}

localhostrun_tunnel() {
  path=$(get_path)                                # get_path should return hosting folder
  read -p $'\e[1;33mEnter Port [default:8080]: \e[0m' port
  port=${port:-8080}

  # start local server
  php -S 127.0.0.1:"$port" -t "$path" >/dev/null 2>&1 &

  # ensure LOG exists & clean previous
  : > "$LOG"

  echo -e "${C}▶ Starting localhost.run tunnel (background)...${RS}"
  # run ssh tunnel in background, capture output to $LOG
  nohup ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
       -R 80:localhost:"$port" nokey@localhost.run > "$LOG" 2>&1 &

  sleep 6  # give provider time to respond

  # try multiple patterns (prefer .lhr.life then .localhost.run then any https)
  lhr=$(grep -oE 'https://[a-zA-Z0-9._-]*\.lhr\.life' "$LOG" | head -1 || true)
  if [[ -n "$lhr" ]]; then
    echo -e "${G}🔗 Localhost.run (lhr): ${Y}${lhr}${RS}"
  else
    ll=$(grep -oE 'https://[a-zA-Z0-9._-]*localhost\.run' "$LOG" | head -1 || true)
    if [[ -n "$ll" ]]; then
      echo -e "${G}🔗 Localhost.run: ${Y}${ll}${RS}"
    else
      any=$(grep -oE 'https?://[^ ]+' "$LOG" | head -1 || true)
      if [[ -n "$any" ]]; then
        echo -e "${G}🔗 Link found: ${Y}${any}${RS}"
      else
        echo -e "${R}❌ Failed to get localhost.run link.${RS}"
        echo -e "${Y}📜 Last 10 log lines:${RS}"
        tail -n 10 "$LOG"
      fi
    fi
  fi

  echo -e "${C}\nPress Ctrl + C to stop server...${RS}"
  while true; do sleep 1; done
}

tunnelmole_tunnel() {
  path=$(get_path)
  read -p $'\e[1;33mEnter Port [default:8080]: \e[0m' port; port=${port:-8080}
  php -S 127.0.0.1:$port -t "$path" >/dev/null 2>&1 &
  tmole $port >"$LOG" 2>&1 &
  sleep 6
  L=$(getlink)
  [[ -n "$L" ]] && echo -e "${G}🔗 Tunnelmole:${Y} $L${RS}" || echo -e "${R}❌ Failed to get Tunnelmole link${RS}"
}

# 🧭 Menu
menu() {
  banner
  echo -e "${R}[1]${G} Localhost (PHP)"
  echo -e "${R}[2]${G} Python HTTP Server"
  echo -e "${R}[3]${C} Cloudflared Tunnel"
  echo -e "${R}[4]${P} Serveo Tunnel"
  echo -e "${R}[5]${Y} Localhost Tunnel"
  echo -e "${R}[6]${B} Public Tunnel"
  echo -e "${R}[7]${W} Install/Update Packages"
  echo -e "${R}[0]${R} Exit${RS}\n"
  read -p $'\e[1;36mChoose Option: \e[0m' opt

  case $opt in
    1) php_local ;;
    2) python_local ;;
    3) cloudflared_tunnel ;;
    4) serveo_tunnel ;;
    5) localhostrun_tunnel ;;
    6) tunnelmole_tunnel ;;
    7) auto_setup ;;
    0) echo -e "${R}👋 Goodbye Boss!${RS}"; exit ;;
    *) echo -e "${R}❌ Invalid Option!${RS}" ;;
  esac

  echo -e "${C}\nPress Ctrl+C to stop server...${RS}"
  while true; do sleep 1; done
}

menu
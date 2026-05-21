#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# =========================================================
# Upload seletivo de backups XVA para ownCloud via rclone
# =========================================================

# Arquivo de lista recebido por argumento
INPUT_FILE="$1"

# Diretório local dos backups
SOURCE_DIR="/backup"

# Destino remoto
#REMOTE="DiscoVirtual:/LGS/backups"
# Chunk - Aponta para o DiscoVirtual, Hash MD5 e quebra de 3G
REMOTE="DiscoVirtual-Chunk:/LGS/backups"

# Controle de concorrência
LOCK_FILE="/var/lock/rclone_backup.lock"
PID_FILE="/var/run/rclone_backup.pid"

# RClone Parâmetros normal (LOG Mínimo)
RCLONE_PAR=(
    --ignore-existing
    --transfers 1
    --retries 2
    --low-level-retries 2
    --timeout 1h
    --contimeout 30s
    --stats 999999h
    --log-level NOTICE
)

# Arquivo de LOG
LOG_FILE="/var/log/backup-rclone.log"

# Arquivo MD5SUMS
MD5_FILE="${SOURCE_DIR}/MD5SUMS"

# =========================================================
# Função para logging (sem duplicação)
# =========================================================

log_message() {
    # Escreve apenas no arquivo de log (sem tee, sem duplicação)
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# =========================================================
# Função para executar o backup (dentro do lock)
# =========================================================

run_backup() {
    log_message "========================================================="
    log_message "INÍCIO DO UPLOAD"
    log_message "========================================================="

    # =========================================================
    # Validação
    # =========================================================

    if [[ -z "$INPUT_FILE" ]]; then
        log_message "[ERRO] Informe o arquivo de lista."
        log_message "Uso: $0 <arquivo_lista>"
        exit 1
    fi

    if [[ ! -f "$INPUT_FILE" ]]; then
        log_message "[ERRO] Arquivo não encontrado: $INPUT_FILE"
        exit 1
    fi

    if ! command -v rclone &> /dev/null; then
        log_message "[ERRO] rclone não encontrado."
        exit 1
    fi

    # =========================================================
    # Upload dos arquivos da lista
    # =========================================================

    while read -r HASH FILE_NAME
    do
        # Ignora linhas vazias
        [[ -z "$FILE_NAME" ]] && continue

        LOCAL_FILE="${SOURCE_DIR}/${FILE_NAME}"

        # Verifica existência local
        if [[ ! -f "$LOCAL_FILE" ]]; then
            log_message "[IGNORADO] Arquivo não encontrado: $LOCAL_FILE"
            continue
        fi

        log_message "[UPLOAD] $FILE_NAME"

        rclone copy "$LOCAL_FILE" "$REMOTE" "${RCLONE_PAR[@]}"

        # Resultado
        if [[ $? -eq 0 ]]; then
            log_message "[OK] Upload concluído: $FILE_NAME"
        else
            log_message "[ERRO] Falha no upload: $FILE_NAME"
        fi

        log_message "---------------------------------------------------------"

    done < "$INPUT_FILE"

    # =========================================================
    # Upload do arquivo MD5SUMS
    # =========================================================

    if [[ -f "$MD5_FILE" ]]; then
        log_message "[UPLOAD] MD5SUMS"

        rclone copyto "$MD5_FILE" "$REMOTE/MD5SUMS" \
            --progress \
            --retries 10 \
            --low-level-retries 20 \
            --timeout 1h \
            --contimeout 60s \
            --log-level INFO 2>&1 | while read line; do log_message "RCLONE: $line"; done

        if [[ $? -eq 0 ]]; then
            log_message "[OK] Upload concluído: MD5SUMS"
        else
            log_message "[ERRO] Falha no upload: MD5SUMS"
        fi
    else
        log_message "[IGNORADO] Arquivo MD5SUMS não encontrado."
    fi

    # =========================================================
    # Finalização
    # =========================================================

    log_message "FIM DO PROCESSO"
    log_message "========================================================="
}

# =========================================================
# Controle de concorrência com flock
# =========================================================

# Tenta adquirir o lock com flock
{
    # Tenta obter lock exclusivo, sem esperar (-n = non-blocking)
    if flock -n 200; then
        # Conseguiu o lock - pode executar o backup
        echo "$$" > "$PID_FILE"
        run_backup
        BACKUP_EXIT=$?
        rm -f "$PID_FILE"
        exit $BACKUP_EXIT
    else
        # Não conseguiu o lock - processo anterior ainda executando
        if [ -f "$PID_FILE" ]; then
            OLD_PID=$(cat "$PID_FILE" 2>/dev/null)
            # Redireciona diretamente para o log (fora do subshell)
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CANCELADO] Um processo de backup em nuvem está em execução (PID: $OLD_PID)"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CANCELADO] Um processo de backup em nuvem está em execução (PID: $OLD_PID)" >> "$LOG_FILE"
        else
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CANCELADO] Um processo de backup em nuvem está em execução"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CANCELADO] Um processo de backup em nuvem está em execução" >> "$LOG_FILE"
        fi
        exit 1
    fi
} 200>"$LOCK_FILE"

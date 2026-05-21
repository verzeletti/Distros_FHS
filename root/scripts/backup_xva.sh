#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# =========================================================
# Script de exportação de VMs XCP-ng
# =========================================================

INPUT_FILE="$1"
BACKUP_DIR="/backup"
LOG_FILE="/var/log/backup-xva.log"
MD5_LIST="${BACKUP_DIR}/MD5SUMS"

# =========================================================
# Gerar lista de argumento
# =========================================================

#xe vm-list is-control-domain=false > /backup/vm-list.txt

# =========================================================
# Validação do argumento
# =========================================================

if [[ -z "$INPUT_FILE" ]]; then
    echo "Uso: $0 <arquivo_lista_vms>"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Arquivo não encontrado: $INPUT_FILE"
    exit 1
fi

# =========================================================
# Inicialização
# =========================================================

mkdir -p "$BACKUP_DIR"

# Tudo vai para o LOG
exec >> "$LOG_FILE" 2>&1

echo "========================================================="
echo "$(date '+%Y-%m-%d %H:%M:%S') - INÍCIO DO PROCESSO"
echo "---------------------------------------------------------"

UUID=""
NAME=""

while IFS= read -r line; do

    # -----------------------------------------------------
    # Captura UUID
    # -----------------------------------------------------

    if [[ $line =~ uuid ]]; then
        UUID=$(echo "$line" | awk -F': ' '{print $2}' | xargs)
    fi

    # -----------------------------------------------------
    # Captura nome da VM
    # -----------------------------------------------------

    if [[ $line =~ name-label ]]; then

        NAME=$(echo "$line" | awk -F': ' '{print $2}' | xargs)

        # Remove sufixo de data
        #BASE_NAME=$(echo "$NAME" | sed -E 's/_BKP[-_][0-9]{4}-[0-9]{2}-[0-9]{2}//')

        # Gera MD5 do UUID
        #UUID_MD5=$(echo -n "$UUID" | md5sum | awk '{print $1}')

        # Nome final do arquivo
        #FILE="${BACKUP_DIR}/${BASE_NAME}_BKP_${UUID_MD5}.xva"
        FILE="${BACKUP_DIR}/${NAME}_${UUID}.xva"

        # -------------------------------------------------
        # Verifica existência
        # -------------------------------------------------

        if [[ -f "$FILE" ]]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') [IGNORADO] Arquivo já existe: $FILE"
            #echo "---------------------------------------------------------"
            continue
        fi

        # -------------------------------------------------
        # Exportação
        # -------------------------------------------------

        echo "$(date '+%Y-%m-%d %H:%M:%S') [EXPORTANDO] $NAME -> $FILE"

        xe vm-export \
            vm="$UUID" \
            filename="$FILE" \
            compress=true

        # -------------------------------------------------
        # Verifica resultado
        # -------------------------------------------------

        if [[ $? -eq 0 ]]; then

            echo "$(date '+%Y-%m-%d %H:%M:%S') [OK] Backup concluído: $FILE"

            # Gera MD5 do arquivo exportado
            FILE_MD5=$(md5sum "$FILE" | awk '{print $1}')

            # Salva catálogo (arquivo de HASH MD5)
            #echo "$FILE_MD5 ; $(basename "$FILE") ; $UUID" >> "$MD5_LIST"
            echo "$FILE_MD5  $(basename "$FILE")" >> "$MD5_LIST"

            echo "$(date '+%Y-%m-%d %H:%M:%S') [MD5] $FILE_MD5"

        else

            echo "$(date '+%Y-%m-%d %H:%M:%S') [ERRO] Falha ao exportar VM: $NAME"

        fi

        #echo "---------------------------------------------------------"

    fi

done < "$INPUT_FILE"

echo "---------------------------------------------------------"
echo "$(date '+%Y-%m-%d %H:%M:%S') - FIM DO PROCESSO"
echo " "
echo " "

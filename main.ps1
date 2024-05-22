# Funkce pro vytvoření souboru nebo složky
function Vytvoreni_souboru {
    param (
        [string]$Cesta,
        [string]$Typ
    )
    if ($Typ -eq "Soubor") {
        New-Item -Path $Cesta -ItemType File -Force
        Write-Host "Soubor '$Cesta' byl úspěšně vytvořen."
    } elseif ($Typ -eq "Adresar") {
        New-Item -Path $Cesta -ItemType Directory -Force
        Write-Host "Adresář '$Cesta' byl úspěšně vytvořen."
    } else {
        Write-Host "Nesprávný typ. Zadejte 'Soubor' nebo 'Adresar'."
    }
}

# Funkce pro přesun
function Presun_souboru {
    param (
        [string]$Domovsky_adresar,
        [string]$Cilovy_adresar
    )
    if(Test-Path $Domovsky_adresar) {
        Move-Item -Path $Domovsky_adresar -Destination $Cilovy_adresar -Force
        Write-Host "Obsah z '$Domovsky_adresar' byl přesunut do '$Cilovy_adresar'."
    } else {
        Write-Host "Požadovaný obsah nelze přesunout, protože neexistuje."
    }
}

# Funkce pro smazaní složky nebo souboru
function Mazani_souboru {
    param (
        [string]$Cesta
    )
    if (Test-Path $Cesta) {
        Remove-Item -Path $Cesta -Recurse -Force
        Write-Host "Obsah '$Cesta' byl úspěšně smazán."
    } else {
        Write-Host "Požadovaný obsah nelze vymazat, protože neexistuje."
    }
}

# Funkce pro kopírování
function Kopirovani_souboru {
    param (
        [string]$Domovsky_adresar,
        [string]$Cilovy_adresar
    )
    if (Test-Path $Domovsky_adresar) {
        Copy-Item -Path $Domovsky_adresar -Destination $Cilovy_adresar -Recurse -Force
        Write-Host "Obsah z '$Domovsky_adresar' byl zkopírován do '$Cilovy_adresar'."
    } else {
        Write-Host "Požadovaný obsah nelze zkopírovat, protože neexistuje."
    }
}

# Funkce pro zálohu
function Zaloha {
    param (
        [string]$Domovsky_adresar,
        [string]$Cilovy_adresar
    )
    if (Test-Path $Domovsky_adresar) {
        # Aktuální datum a čas pro název zálohy
        $date = Get-Date -Format yyyy-MM-dd_HHmm
        $backupName = "Zaloha_$date.zip"
        $backupPath = Join-Path -Path $Cilovy_adresar -ChildPath $backupName
        Compress-Archive -Path $Domovsky_adresar -DestinationPath $backupPath
        Write-Host "Záloha byla úspěšně vytvořena na $backupPath."
    } else {
        Write-Host "Požadovaný obsah nelze zálohovat, protože neexistuje."
    }
}

# Menu pro uživatele
function Vyber_ukonu {
    Write-Host "Vyberte úkol:"
    Write-Host "1: Vytvořte soubor nebo adresář"
    Write-Host "2: Smažte soubor nebo adresář"
    Write-Host "3: Zálohujte soubor nebo adresář"
    Write-Host "4: Přesuňte soubor nebo adresář"
    Write-Host "5: Zkopírujte soubor nebo adresář"
    Write-Host "0: Konec"
}

# Hlavní smyčka skriptu
do {
    Vyber_ukonu
    $selection = Read-Host "Vyberte operaci"

    switch ($selection) {
        1 {
            $Cesta = Read-Host "Zadejte cestu"
            $Typ = Read-Host "Zadejte typ (Soubor/Adresar)"
            Vytvoreni_souboru -Cesta $Cesta -Typ $Typ
        }
        2 {
            $Cesta = Read-Host "Zadejte cestu ke smazání"
            Mazani_souboru -Cesta $Cesta
        }
        3 {
            $Domovsky_adresar = Read-Host "Zadejte cestu"
            $Cilovy_adresar = Read-Host "Zadejte cílovou cestu"
            Zaloha -Domovsky_adresar $Domovsky_adresar -Cilovy_adresar $Cilovy_adresar
        }
        4 {
            $Domovsky_adresar = Read-Host "Zadejte cestu"
            $Cilovy_adresar = Read-Host "Zadejte cílovou cestu"
            Presun_souboru -Domovsky_adresar $Domovsky_adresar -Cilovy_adresar $Cilovy_adresar
        }
        5 {
            $Domovsky_adresar = Read-Host "Zadejte cestu"
            $Cilovy_adresar = Read-Host "Zadejte cílovou cestu"
            Kopirovani_souboru -Domovsky_adresar $Domovsky_adresar -Cilovy_adresar $Cilovy_adresar
        }
        0 {
            Write-Host "Konec"
        }
        default {
            Write-Host "Neplatný výběr, zkuste to znovu."
        }
    }
} while ($selection -ne 0)

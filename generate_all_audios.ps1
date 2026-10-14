Add-Type -AssemblyName System.Speech

# Output folder
$outputFolder = "E:\EnglishApp\Audios"
if (-not (Test-Path $outputFolder)) {
    New-Item -ItemType Directory -Path $outputFolder | Out-Null
}

$jsonPath = "E:\EnglishApp\phrases.json"
if (-not (Test-Path $jsonPath)) {
    Write-Error "JSON file not found at $jsonPath"
    exit
}

# Clean string function to generate friendly filenames using [char] codes to avoid encoding issues
function Sanitize-String($str) {
    # Replace lowercase accented vowels
    $str = $str.Replace([char]225, 'a')
    $str = $str.Replace([char]233, 'e')
    $str = $str.Replace([char]237, 'i')
    $str = $str.Replace([char]243, 'o')
    $str = $str.Replace([char]250, 'u')
    
    # Replace uppercase accented vowels
    $str = $str.Replace([char]193, 'A')
    $str = $str.Replace([char]201, 'E')
    $str = $str.Replace([char]205, 'I')
    $str = $str.Replace([char]211, 'O')
    $str = $str.Replace([char]218, 'U')
    
    # Replace ñ, Ñ, ü, Ü
    $str = $str.Replace([char]241, 'n')
    $str = $str.Replace([char]209, 'N')
    $str = $str.Replace([char]252, 'u')
    $str = $str.Replace([char]220, 'U')
    
    # Replace spaces with underscores
    $str = $str -replace '\s+', '_'
    # Remove non-alphanumeric/underscore/hyphen characters
    $str = $str -replace '[^a-zA-Z0-9_\-]', ''
    return $str
}

Write-Host "Reading phrases from JSON..."
$phrases = Get-Content -Raw -Path $jsonPath -Encoding utf8 | ConvertFrom-Json

# Extract unique categories maintaining order
$categories = [System.Collections.Generic.List[string]]::new()
foreach ($p in $phrases) {
    if (-not $categories.Contains($p.category)) {
        $categories.Add($p.category)
    }
}

$totalCategories = $categories.Count
Write-Host "Found $totalCategories categories."

# Track progress
$counter = 1

foreach ($cat in $categories) {
    # Generate filename
    # Category looks like: "1-25: Saludos y expresiones básicas"
    $parts = $cat.Split(":", 2)
    $range = ""
    $title = $cat
    
    if ($parts.Count -eq 2) {
        $range = $parts[0].Trim()
        $title = $parts[1].Trim()
    }
    
    $cleanRange = $range -replace '[^0-9\-]', ''
    $cleanTitle = Sanitize-String($title)
    
    # Pad counter with zero (e.g. 01, 02, ..., 80)
    $paddedCounter = $counter.ToString("00")
    $fileName = ""
    if ($cleanRange -ne "") {
        $fileName = "${paddedCounter}_${cleanRange}_${cleanTitle}"
    } else {
        $fileName = "${paddedCounter}_${cleanTitle}"
    }
    
    $wavPath = Join-Path $outputFolder "${fileName}.wav"
    $mp3Path = Join-Path $outputFolder "${fileName}.mp3"
    
    Write-Host "[$counter/$totalCategories] Generating: ${fileName}.mp3..."
    
    # Filter phrases for this category
    $catPhrases = $phrases | Where-Object { $_.category -eq $cat }
    
    try {
        # Initialize Speech Synthesizer for this track
        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $synth.SetOutputToWaveFile($wavPath)
        
        $pb = New-Object System.Speech.Synthesis.PromptBuilder
        
        # Intro: Category name read in Spanish (written without accents for safety)
        $pb.StartVoice("Microsoft Helena Desktop")
        $pb.AppendText("Categoria: " + $title + ".")
        $pb.EndVoice()
        $pb.AppendBreak([TimeSpan]::FromSeconds(2.0))
        
        # Loop phrases
        foreach ($p in $catPhrases) {
            # 1. Speak English (US)
            $pb.StartVoice("Microsoft Zira Desktop")
            $pb.AppendText($p.english)
            $pb.EndVoice()
            
            # 2. Silence Pause (2.5 seconds)
            $pb.AppendBreak([TimeSpan]::FromSeconds(2.5))
            
            # 3. Speak Spanish (Spain)
            $pb.StartVoice("Microsoft Helena Desktop")
            $pb.AppendText($p.spanish)
            $pb.EndVoice()
            
            # 4. Silence between phrases (3.0 seconds)
            $pb.AppendBreak([TimeSpan]::FromSeconds(3.0))
        }
        
        # Perform TTS synthesis
        $synth.Speak($pb)
        $synth.Dispose()
        
        # Convert WAV to MP3 using ffmpeg
        if (Test-Path $wavPath) {
            # ffmpeg parameters: -y (overwrite), -i (input file), -codec:a libmp3lame (mp3 encoder), -qscale:a 4 (good VBR quality)
            & ffmpeg -y -i $wavPath -codec:a libmp3lame -qscale:a 4 $mp3Path 2>$null
            
            # Remove temporary WAV
            if (Test-Path $mp3Path) {
                Remove-Item $wavPath
            } else {
                Write-Warning "Could not convert ${fileName}.wav to MP3."
            }
        }
    }
    catch {
        Write-Error "Error processing category '$cat': $_"
        if ($null -ne $synth) { $synth.Dispose() }
    }
    
    $counter++
}

Write-Host "Success! All $totalCategories audio files generated in: $outputFolder"

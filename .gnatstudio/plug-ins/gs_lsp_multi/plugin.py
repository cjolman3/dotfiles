# plugin.py
#
# Minimal clangd LSP plugin for GNAT Studio 23.0w.
# No gs_utils.lsp dependency.

import GPS

# ---------------------------------------------------------
# Simple LSP wrapper (old GNAT Studio LSP API)
# ---------------------------------------------------------
class ClangdLSP(GPS.LanguageServer):

    def __init__(self):
        super().__init__(
            name="C/C++ (clangd)",
            language_id="cpp"
        )
        self.extensions = [
            ".c", ".h",
            ".cpp", ".hpp",
            ".cxx", ".hxx",
            ".cc", ".hh"
        ]
        self.proc = None

    def start(self):
        GPS.Console("Messages").write("[clangd] start() called\n")

        if self.proc:
            GPS.Console("Messages").write("[clangd] already running\n")
            return

        try:
            self.proc = GPS.Process(
                command=["clangd", "--log=verbose"],
                block_on_start=False,
                on_exit=self.on_exit
            )
            GPS.Console("Messages").write("[clangd] process created\n")
            self.set_process(self.proc)
        except Exception as E:
            GPS.Console("Messages").write(f"[clangd] ERROR: {E}\n")


    def stop(self):
        if self.proc:
            try:
                self.proc.kill()
            except:
                pass
            self.proc = None

    def on_exit(self, proc):
        GPS.Console("Messages").write("clangd exited.\n")
        self.proc = None


# ---------------------------------------------------------
# Setup (called by GNAT Studio at load time)
# ---------------------------------------------------------
def setup():
    GPS.Console("Messages").write("Loading clangd plugin...\n")

    provider = ClangdLSP()

    # Register for both C and C++
    GPS.Languages.register_provider("c", provider)
    GPS.Languages.register_provider("cpp", provider)

    GPS.Console("Messages").write("clangd provider registered.\n")


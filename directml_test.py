import sys
import platform

print("DirectML test script")
print("Python:", sys.version.splitlines()[0])
print("Executable:", sys.executable)
print("Platform:", platform.platform())

try:
    import importlib
    torch = importlib.import_module('torch')
    print("PyTorch found, version", getattr(torch, '__version__', 'unknown'))
    try:
        print("CUDA available:", torch.cuda.is_available())
    except Exception as e:
        print("Could not query CUDA availability:", e)
except Exception as e:
    print("PyTorch not available or import failed:", e)

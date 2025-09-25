import sys, importlib, pkgutil, subprocess
print('Python exe:', sys.executable)
print('sys.path order:')
for p in sys.path:
    print('  ', p)
print('\nImport google and show __path__')
import google
print('google package __file__:', getattr(google, '__file__', None))
print('google package __path__:', list(getattr(google, '__path__', [])))
print('\nFind specs:')
for name in ('google', 'google.protobuf', 'google.protobuf.runtime_version'):
    spec = importlib.util.find_spec(name)
    print(name, '->', spec.origin if spec else None)

print('\nCheck for runtime_version.py under google.__path__')
for p in list(getattr(google, '__path__', [])):
    import os
    f = os.path.join(p, 'protobuf', 'runtime_version.py')
    print(p, '->', os.path.exists(f), f)

print('\nInstalled protobuf in this interpreter:')
try:
    import google.protobuf as pb
    print('protobuf.__version__', getattr(pb, '__version__', None))
    print('pb.__file__', getattr(pb, '__file__', None))
except Exception as e:
    print('import google.protobuf failed:', e)

print('\nPip list (venv):')
import pkg_resources
for d in pkg_resources.working_set:
    if d.key in ('protobuf','tensorflow','optimum','onnxruntime','onnxruntime-directml'):
        print(d.key, d.version, d.location)

# Try to detect system Python protobuf (if different interpreter exists)
print('\nAttempt to run system python -m pip show protobuf (if available)')
import shutil
sys_python = shutil.which('python')
print('which python in PATH:', sys_python)
try:
    out = subprocess.check_output(['python','-m','pip','show','protobuf'], stderr=subprocess.DEVNULL, text=True)
    print(out.strip())
except Exception as e:
    print('system python pip show failed or python not same as venv:', e)

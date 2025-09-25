import pkg_resources

print('Python executable:', __import__('sys').executable)
try:
    import google.protobuf as pb
    print('protobuf package __version__:', getattr(pb, '__version__', 'unknown'))
    print('protobuf file:', getattr(pb, '__file__', 'unknown'))
    try:
        from google.protobuf import runtime_version
        print('runtime_version import: OK ->', runtime_version)
    except Exception as e:
        print('runtime_version import: FAILED ->', type(e).__name__, e)
except Exception as main_e:
    print('Import google.protobuf failed:', type(main_e).__name__, main_e)

print('\nInstalled protobuf distribution info:')
found = False
for d in pkg_resources.working_set:
    if d.key == 'protobuf':
        print(d)
        found = True
        break
if not found:
    print('protobuf not found in working_set')

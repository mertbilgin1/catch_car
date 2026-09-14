import json

with open(r'C:\Users\Pc\.gemini\antigravity\brain\462708a3-5eed-4d22-9e15-839459593ae3\.system_generated\steps\239\output.txt', encoding='utf-8') as f:
    data = json.load(f)

for s in data['screens']:
    if 'profile' in s['name'].lower():
        print(s['id'], s['name'])

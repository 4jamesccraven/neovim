import json
from pathlib import Path
from operator import itemgetter

PLUGINS_JSON: Path = Path(__file__).parents[1] / 'plugins.json'
extract_plugin = itemgetter('gh')

TEMPLATE = \
'''return {{
{0}
}}
'''

def main() -> None:
    with open(PLUGINS_JSON, 'r', encoding='utf8') as f:
        plugins_json: dict = json.load(f)

    plugin_names = map(extract_plugin, plugins_json.values())
    lazy_fmt = map(lambda p: f'    {{ "{p}" }},', plugin_names)
    plugin_list = '\n'.join(list(lazy_fmt))


    print(TEMPLATE.format(plugin_list), end='')

if __name__ == '__main__':
    main()

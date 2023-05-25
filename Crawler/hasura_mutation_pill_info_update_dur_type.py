from async_request_manager import RequestManager
import asyncio
import json
import filter_options

def main():
    dur_taboo_file = open('dur_output.json', 'r', encoding='UTF-8')
    dur_taboos = json.load(dur_taboo_file)['data']

    item_seq: set[int] = {dur_taboo['item_seq'] for dur_taboo in dur_taboos}
    mixture_item_seq: set[int] = {dur_taboo['mixture_item_seq'] for dur_taboo in dur_taboos}

    item_seq_set: set[int] = item_seq | mixture_item_seq


if __name__ == '__main__':
    main()

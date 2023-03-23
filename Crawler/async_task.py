import asyncio
import random

async def request(page):
    await asyncio.sleep(random.random())
    return page

async def main():
    # method 1
    ret = await asyncio.gather(*[request(page) for page in range(100)])
    print(ret)


    # method 2
    tasks = []
    for i in range(100):
        t = asyncio.create_task(request(i))
        tasks.append(t)
    done, pending = await asyncio.wait(tasks, return_when=asyncio.ALL_COMPLETED)
    for task in done:
        result = await task
        print(result)

if __name__ == "__main__":
    asyncio.run(main())
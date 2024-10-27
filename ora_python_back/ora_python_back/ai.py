import json
import re
from asgiref.sync import async_to_sync
from django.views.decorators.csrf import csrf_exempt
import aiohttp # type: ignore
from django.http import JsonResponse, HttpResponse
import logging
import difflib
import os


logger = logging.getLogger(__name__)
node_backend_server = os.environ.get("NODE_BACKEND_SERVER")


async def get_data_from_db():
    async with aiohttp.ClientSession() as session:
        try:
            async with session.get(f"{node_backend_server}/company") as response:
                if response.status == 200:
                    logger.info("신호를 성공적으로 보냈습니다.")
                    response_text = await response.text()
                    logger.info(f"응답 내용: {response_text}")
                    response_json = await response.json()
                    print(response_json)
                    return response_json
                else:
                    logger.error(f"오류 발생: 상태 코드 {response.status}")
                    return None
        except Exception as e:
            logger.error(f"요청 중 오류 발생: {e}")
            return None

@csrf_exempt
@async_to_sync
async def start_program(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        user_input = data.get('message')
        address = data.get('address')
        if user_input is None:
            return JsonResponse({'error': 'Missing message parameter'}, status=400)
         
    # 대화 시작
        print("대화를 시작하려면 '안녕오라'라고 말해보세요.")
        # user_input = input("유저 : ")
        # if user_input != '안녕오라':
        #     # 이상한 입력하면 대화 종료
        #     print(json.dumps({"message": "대화가 종료됩니다.", "company": []}, ensure_ascii=False))
        #     return
        # else:
        print("무엇을 도와드릴까요?")
            # user_input = input("유저 : ")
        result = await recommend_store(user_input,address)
        print(result)
        return result
    
    return JsonResponse({'error': 'Invalid request method'}, status=405)


async def recommend_store(user_input,address):
    # dataset.json
    dataset = await get_data_from_db()
    # with open('dataset.json', 'r', encoding='utf-8') as f:
    #     dataset = json.load(f)
    
    # 유저 입력에서 키워드 추출
    keywords = [word for word in user_input.split()]
    # 일치하는 가게 찾기 (store_type의 유사도 기반으로 찾음)
    matching_stores = []
    store_type = ""
    for store in dataset:
        # dataset 내에 있는 가게의 type들 for문으로 순회
        for t in store['type']:
            # type 정보를 list로 변환
            store_types_list = [str(value) for value in t.values()]

            for keyword in keywords:
                # 유저 입력 키워드랑 가게 type 정보 비교해서 유사도 0.6 이상되는 일치 항목 찾음
                match = difflib.get_close_matches(keyword, store_types_list, n=1, cutoff=0.6)
                if match:
                    # 일치하는 가게 matching_stores 리스트에 추가
                    matching_stores.append({"location": store['location'], "name": store['name']})

                    # store_type은 dataset.json에서 각 가게별 type의 first_type 가져옴
                    store_type = t['first_type']
                    break
    
    if matching_stores:
        # 유저 위치 설정!!!!
        user_location = address

        # 유저 위치에서 주소만 추출 (불용어 없앰)
        address_keywords = re.findall(r'[가-힣]+(?:도|시|군|구|로|면|동)', user_location)
        
        # 일단 유저 입력과 가게 주소에서 상위 2개 주소 정보가 일치하면 추천해줌
        # 예시) 가게가 '서울시 성북구 정릉동'이라면 사용자 위치가 '서울시 성북구 동소문동' 이러면 상위 2개 일치하므로 추천해줌
        #       그런데 사용자 위치가 '서울시 강남구 (어쩌구)' 하면 멀기 때문에 추천안해줌.
        filtered_stores = [store for store in matching_stores if address_keywords[:2] == store['location'].split()[:2]]
        
        # 위치 기반으로 필터링된 가게가 존재할 때
        if filtered_stores:
            location_str = ', '.join(set(store["location"] for store in filtered_stores))
            response = {
                "message": f"{location_str}에 위치한 {store_type}을 추천드릴게요",
                "company": filtered_stores
            }
            return JsonResponse(response)
          
        # 위치 기반으로 필터링 했더니 가게가 없어졌을 때
        else:
            response = {
                "message": f"죄송합니다. 현재 계신 곳 주변에 적절한 {store_type}을 찾지 못했습니다.",
                "company": []
            }
            return JsonResponse(response)
            
    # 아예 쌩판 다른 가게 type의 추천 요청이 들어왔을 때
    # 예시) 한식당, 문구점 뭐 이런거
    else:
        response = {
            "message": "죄송합니다, 현재 해당 유형의 가게 정보는 존재하지 않습니다.",
            "company": []
        }
        return JsonResponse(response)
     






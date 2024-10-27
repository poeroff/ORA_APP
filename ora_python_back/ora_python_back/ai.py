# import os
# from pathlib import Path
# import requests
# from django.http import JsonResponse, HttpResponse
# import logging
# import aiohttp # type: ignore
# import openai  # openai 버전 0.28.0 , pip install openai==0.28.0
# import json
# from asgiref.sync import async_to_sync
# from django.views.decorators.csrf import csrf_exempt
# import environ
# from sklearn.feature_extraction.text import TfidfVectorizer
# import nltk
# from konlpy.tag import Okt
# from sklearn.feature_extraction.text import TfidfVectorizer
# nltk.download('punkt')

# nltk.data.path.append("/app/ora_python_back/nltk_data")
# nltk.download('averaged_perceptron_tagger') 
# nltk.download('stopwords')


# logger = logging.getLogger(__name__)





# # OpenAI API 키 설정




# # 대화를 위한 초기 system message 역할 부여 
# def initialize_conversation():
#     return [
#         {
#             "role": "system",
#             "content": """
#             You are an assistant for 'ORA,' a service that provides recommendations for businesses such as bakeries, ski equipment rentals, theaters, health clinics, and marketplace apps. When discussing store-related information, strictly use the provided database (database_2.json), and do not create any stores, menu items, services, ratings, atmospheres, or locations that are not in the database. You must not provide false information to users.

#             When recommending a store, you must remember that store throughout the conversation unless the user requests a different store or explicitly changes the topic. Even if the user doesn’t mention the store name again, assume they are asking about the most recently recommended store.

#             For example:

#             If the user asks about the atmosphere, ratings, location, or menu items, provide information for the most recently recommended store unless otherwise specified. Before recommending a store, always ask for the user’s location. Afterward, you can answer detailed questions. When a user asks for specific information, always ask for their location unless it has already been provided. For example, ask, "Where do you live?" or "Can you tell me your city or neighborhood?"

#             Once a location is provided, remember it throughout the conversation unless the user mentions moving or changing location. Do not ask about their location again unless they mention a new one.

#             When providing store information, never give all the details at once:

#             When first recommending a store, provide only the “location” and “name” based on database_2.json. If the user asks about ratings, generate the response using the “total_rating” from database_2.json. If the user asks about the atmosphere, generate the response using “atmosphere” from database_2.json. If the user asks for a detailed location, generate the response using “location” from database_2.json. If the user asks about the menu or services, generate the response using the “shop_menu” items and “price” from database_2.json. However, if the user asks whether a store offers a particular menu item or service not listed in the database, inform them that the store does not offer it.

#             If the user asks to make a reservation, ask for their name, desired reservation time, and the menu or service they wish to reserve, one by one. The name, reservation time, and menu or service are essential for making the reservation. Ask these questions one at a time, waiting for the user’s response before proceeding.

#             If you receive a non-reservation-related question while discussing a reservation, kindly answer the user’s question using the information in database_2.json. After resolving their other inquiry, resume the reservation process by asking any remaining questions.

#             First, ask for their name. After receiving the name, ask for the reservation time. After receiving the reservation time, ask about the menu or service they wish to reserve. If the store offers food (e.g., bakery), ask, “Which menu item would you like to reserve?” If the store provides rental, theater, or health consultation services, ask, “Which service would you like to reserve?” Once you have all the information, remind the user of the store, item or service, time, and reservation name to confirm the accuracy. Then ask if they would like to receive a confirmation message.

#             Conversations should proceed naturally, generating responses step by step based on the situation. Each response should adjust dynamically and consist of only one sentence. Never exceed two sentences.

#             If the user asks about a store or service that is not in the database, inform them that you cannot provide that information instead of creating a new store. Never, under any circumstances, create a store or service that does not exist in the database. However, even if a user does not directly mention a service, you should suggest similar businesses based on the context.

#             For example, if three users from Daegu mention that they have ear pain, tooth pain, or stomach pain, recommend "건강드림보건소" even if the name doesn't explicitly include ENT, dental, or internal medicine, because those services are offered.

#             Responses should be concise and always limited to one sentence. Never exceed two sentences.

#             When a store is recommended and the user asks a follow-up question (e.g., about atmosphere, rating, location, menu, or price), automatically assume the user is asking about the most recently recommended store. Do not ask redundant questions or fail to respond based on the store that was recommended. Always provide answers related to the most recent recommendation unless the user specifies otherwise.

#             Provide empathetic and friendly conversation to the user. The conversation should not be too formal or rigid. Make the user feel as though they are talking to a real person.
#             """
#         }
#     ]

# # 사용자 상태 저장
# chat_state = {
#     'location': None,  # 사용자 위치
#     'last_recommended_store': None  # 최근에 추천된 가게 저장
# }

# # 사용자 요청에 맞는 가게 정보를 찾음
# def find_relevant_store(user_input, store_data):
#     user_input = user_input.lower()

#     # 가게 유형 or 메뉴 항목 기준으로 매칭 (확장된 type 필드 처리)
#     for store in store_data:  # store_data 자체가 리스트이므로 이를 순회
#         store_types = [val for val in store['type'][0].values() if isinstance(val, str)]
#         if any(store_type.lower() in user_input for store_type in store_types) or any(item['item'].lower() in user_input for item in store['shop_menu']):
#             return store
#     return None

# # OpenAI API를 통해 대화의 의도를 파악하고 유동적 응답 생성

# async def analyze_user_intent(conversation, user_input):
#     conversation.append({"role": "user", "content": user_input})
#     openai.api_key = os.environ.get("AI_APIKEY")
 

#     async with aiohttp.ClientSession() as session:
#         async with session.post(
#             "https://api.openai.com/v1/chat/completions",
#             headers={
#                 "Authorization": f"Bearer {openai.api_key}",
#                 "Content-Type": "application/json"
#             },
#             json={
#                 "model": "gpt-4o",
#                 "messages": conversation,
#                 "max_tokens": 100,
#                 "temperature": 0.4
#             }
#         ) as response:
#             response_json = await response.json()
#             if "choices" not in response_json:
#                 return "API 응답 오류: 'choices' 키가 없습니다."
            
#             response_text = response_json["choices"][0]["message"]["content"]
#             conversation.append({"role": "assistant", "content": response_text})
#             return response_text

# # 가게 정보를 바탕으로 유동적인 응답 생성 (매번 새로운 응답 생성)

# async def fetch_store_info(conversation, store, user_input):
#     # 가게의 위치, 분위기, 메뉴 등 정보 기반으로 답변 생성
#     menu_items = ', '.join([f"{item['item']} ({item['price']})" for item in store['shop_menu']])
#     store_info = f"""
#     Store Name: {store['name']}
#     Location: {store['location']}
#     Atmosphere: {', '.join([store['atmosphere'][0][f"{key}_atmosphere"] for key in ['first', 'second', 'three'] if store['atmosphere'][0][f"{key}_atmosphere"]])}
#     Menu: {', '.join([f"{item['item']} ({item['price']})" for item in store['shop_menu']])}
#     Rating: {store['total_rating']}
#     """

#     # "잘못된 정보" 메시지 피함
#     conversation.append({"role": "system", "content": f"Provide correct store information without indicating any errors: {store_info}"})

#     async with aiohttp.ClientSession() as session:
#         async with session.post(
#             "https://api.openai.com/v1/chat/completions",
#             headers={
#                 "Authorization": f"Bearer {openai.api_key}",
#                 "Content-Type": "application/json"
#             },
#             json={
#                 "model": "gpt-4o",
#                 "messages": conversation + [{
#                     "role": "system",
#                     "content": f"""
#                     You must use the following store information to answer the user:
#                     Store Name: {store['name']}
#                     Location: {store['location']}
#                     Atmosphere: {', '.join([store['atmosphere'][0][f"{key}_atmosphere"] for key in ['first', 'second', 'three'] if store['atmosphere'][0][f"{key}_atmosphere"]])}
#                     Menu: {menu_items}
#                     Rating: {store['total_rating']}
#                     Answer the user based strictly on this store information and respond naturally in a human-like manner.
#                     - If the user asks about the store's **location**, provide the "Location".
#                     - If they ask about **atmosphere**, provide "Atmosphere".
#                     - If they ask about **menu items** or **prices**, provide the "Menu" including prices.
#                     - If they ask about the **rating**, provide the "Rating".
#                     Do not create any new information outside of what is provided in the store data.
#                     Generate responses that feel conversational and flow naturally, while strictly adhering to the provided store data. 
#                     Ensure that your response contains only one sentence at a time, and never exceed two sentences.
#                     """
#                 }],
#                 "max_tokens": 100,
#                 "temperature": 0.4
#             }
#         ) as response:
#             response_json = await response.json()
#             if "choices" not in response_json:
#                 return "API 오류 : 'choices' 키 없음."

#             return response_json["choices"][0]["message"]["content"]

# # 대화 상태 관리 함수

# async def handle_conversation(conversation, user_input, store_data):
#     global chat_state

#     # 사용자의 의도 분석
#     intent_response = await analyze_user_intent(conversation, user_input)
    
#     # 이전에 추천한 가게를 사용자가 언급하지 않아도 기억하도록 처리
#     if chat_state['last_recommended_store']:
#         store = chat_state['last_recommended_store']
#     else:
#         store = find_relevant_store(user_input, store_data)
#         if store:
#             chat_state['last_recommended_store'] = store

#     if store:
#         # 가게 정보 기반 응답을 생성
#         store_info_response = await fetch_store_info(conversation, store, user_input)
#         return store_info_response
    
#     return intent_response  # 가게 정보가 없으면 일반 대화 스타일 응답

# # 대화
# async def chat_with_oracle(store_data,user_input,address):
#     conversation = initialize_conversation()
#     if user_input.lower() == "안녕오라":
#         greeting = "안녕하세요! 무엇을 도와드릴까요?"
#         conversation.append({"role": "assistant", "content": greeting})
#         return greeting
#     else:
#         response = await handle_conversation(conversation, user_input, store_data)
#         return response
# @csrf_exempt
# @async_to_sync
# async def start_conversation(request):
#     if request.method == 'POST':
#         try:
#             data = json.loads(request.body)
#             user_input = data.get('message')
#             address = data.get('address')
       
          
            
#             if user_input is None:
#                 return JsonResponse({'error': 'Missing message parameter'}, status=400)
            
#             store_data = await get_data_from_db()
          
#             if store_data is None:
#                 return JsonResponse({'error': 'Failed to fetch store data'}, status=500)
                
#             response = await chat_with_oracle(store_data, user_input, address)
#             text = extract_keywords(response);
            
           

#             return JsonResponse({'message': response, "NLP" : text})
            
#         except json.JSONDecodeError:
#             return JsonResponse({'error': 'Invalid JSON'}, status=400)
#         except Exception as e:
#             logger.error(f"Error in start_conversation: {e}")
#             return JsonResponse({'error': str(e)}, status=500)
#     else:
#         return JsonResponse({'error': 'Only POST requests are allowed'}, status=405)
    
# def ensure_nltk_data():
#     nltk_data_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'nltk_data')
#     print(nltk_data_path)
#     os.makedirs(nltk_data_path, exist_ok=True)
#     nltk.data.path.append(nltk_data_path)

#     resources = ['punkt', 'stopwords', 'averaged_perceptron_tagger']
#     for resource in resources:
#         try:
#             nltk.data.find(f'tokenizers/{resource}')
#         except LookupError:
#             print(f"Downloading {resource}...")
#             nltk.download(resource, download_dir=nltk_data_path, quiet=True)
    
#     # 명시적으로 punkt_tab 다운로드
#     try:
#         nltk.data.find('tokenizers/punkt_tab')
#     except LookupError:
#         print("Downloading punkt_tab...")
#         nltk.download('punkt_tab', download_dir=nltk_data_path, quiet=True)

# def extract_keywords(AI_TEXT,top_n=5):
#     ensure_nltk_data()
#     okt = Okt()
#     try:
#         # 텍스트 전처리
#         stop_words = set(['을', '를', '이', '가', '은', '는', '에', '의', '와', '과', '으로', '로', '에서'])
#         # 형태소 분석 및 명사 추출
#         nouns = okt.nouns(AI_TEXT)
        
#         # 불용어 제거 및 2글자 이상의 명사만 선택
#         filtered_nouns = [noun for noun in nouns if noun not in stop_words and len(noun) > 1]
        
#         # 명사 리스트를 문자열로 변환
#         preprocessed_text = ' '.join(filtered_nouns)
        
#         # TF-IDF 벡터화
#         vectorizer = TfidfVectorizer()
#         tfidf_matrix = vectorizer.fit_transform([preprocessed_text])
        
#         # 단어와 그에 해당하는 TF-IDF 점수를 추출
#         feature_names = vectorizer.get_feature_names_out()
#         tfidf_scores = tfidf_matrix.toarray()[0]
        
#         # TF-IDF 점수가 높은 순으로 정렬하여 상위 n개 추출
#         word_scores = list(zip(feature_names, tfidf_scores))
#         word_scores.sort(key=lambda x: x[1], reverse=True)
#         top_words = word_scores[:top_n]
#         return [word for word, score in top_words]


#     except Exception as e:
#         print(f"키워드 추출 중 오류 발생: {str(e)}")
#         return []



import json
import re
from asgiref.sync import async_to_sync
from django.views.decorators.csrf import csrf_exempt
import aiohttp # type: ignore
import requests
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
        print(json.dumps({"message": "대화를 시작하려면 '안녕오라'라고 말해보세요.", "company": []}, ensure_ascii=False))
        # user_input = input("유저 : ")
        # if user_input != '안녕오라':
        #     # 이상한 입력하면 대화 종료
        #     print(json.dumps({"message": "대화가 종료됩니다.", "company": []}, ensure_ascii=False))
        #     return
        # else:
        print(json.dumps({"message": "무엇을 도와드릴까요?", "company": []}, ensure_ascii=False))
            # user_input = input("유저 : ")
        result = await recommend_store(user_input,address)
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
        # 유저 위치 설정!!!!@
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
            "message": "현재 해당 유형의 가게 정보는 존재하지 않습니다.",
            "company": []
        }
        return JsonResponse(response)
     



    
    
def hello_world(request):
     return HttpResponse("Hello World");



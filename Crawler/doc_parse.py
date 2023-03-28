import xmltodict


def doc_to_html(doc: str) -> str:
    '''
        식품의약품안전처_의약품 제품 허가정보 API의 _DOC_DATA로 끝나는 컬럼의 데이터를 받으면
        html 형식으로 바꿔준다.
        example:
            '<div>
                ...중략...
            </div>'

    '''

    if doc is None or len(doc) <= 0:
        return

    # front-end 측의 요청으로 묶어서 보내줌
    out: str = '<div>'
    docs = xmltodict.parse(doc)

    # 아래 부터는 식품안전처_의약품 제품 허가정보 API에서 작성한 포맷을 파싱한다.

    # 비어 있는 태그
    docs: list[dict] = docs['DOC']['SECTION']

    # 한약에 제제가 여러개인 경우 처리
    if not isinstance(docs, list):
        docs = [docs]

    doc: dict = {}

    for doc in docs:
        out += doc['@title']
        if not ('ARTICLE' in doc.keys()):
            continue
        # 소제목
        if not isinstance(doc['ARTICLE'], list):
            doc['ARTICLE'] = [doc['ARTICLE']]
        for article in doc['ARTICLE']:
            out += article['@title']

            # 내부 단락
            if 'PARAGRAPH' in article.keys():

                if not isinstance(article['PARAGRAPH'], list):
                    article['PARAGRAPH'] = [article['PARAGRAPH']]

                for paragraph in article['PARAGRAPH']:

                    # table
                    if paragraph['@tagName'] == 'table':
                        out += '<table>'
                        out += paragraph['#text']
                        out += '</table>'
                    # 일반 글
                    if paragraph['@tagName'] == 'p':
                        if not ('#text' in paragraph.keys()):
                            continue
                        out += '<p>'
                        out += paragraph['#text']
                        out += '</p>'
    out += '</div>'
    return out

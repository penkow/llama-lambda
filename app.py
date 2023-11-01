from llama_cpp import Llama
import os

MODEL_NAME = os.environ['MODEL_NAME']

llm = Llama(model_path=f"./model/{MODEL_NAME}")

def handler(event, context):
    prompt = event['prompt']
    max_tokens = int(event['max_tokens'])    
    output = llm(prompt, max_tokens=max_tokens, echo=True)
    return output

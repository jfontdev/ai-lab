const express = require('express');

const app = express();
app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.post('/chat', async (req, res) => {
  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: 'Prompt is required' });
  }

  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');

  const startTime = Date.now();
  let tokenCount = 0;
  let fullText = '';

  try {
    const ollamaResponse = await fetch('http://localhost:11434/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'llama3',
        prompt,
        stream: true
      })
    });

    const reader = ollamaResponse.body.getReader();
    const decoder = new TextDecoder();

    while (true) {
      const { value, done } = await reader.read();
      if (done) break;

      const chunk = decoder.decode(value, { stream: true });
      const lines = chunk.split('\n').filter(Boolean);

      for (const line of lines) {
        try {
          const json = JSON.parse(line);

          if (json.response) {
            fullText += json.response;
            tokenCount++;

            res.write(`data: ${json.response}\n\n`);
          }

          if (json.done) {
            const durationSec = (Date.now() - startTime) / 1000;
            const tps = tokenCount / durationSec;

            res.write(`data: \\n--- METRICS ---\\n\n`);
            res.write(`data: tokens: ${tokenCount}\\n\n`);
            res.write(`data: duration: ${durationSec.toFixed(2)}s\\n\n`);
            res.write(`data: tokens/sec: ${tps.toFixed(2)}\\n\n`);
            res.write(`data: [DONE]\\n\n`);

            res.end();
            return;
          }
        } catch (e) {
          // ignore malformed JSON chunks
        }
      }
    }

  } catch (err) {
    console.error(err);
    res.write(`data: ERROR\\n\n`);
    res.end();
  }
});

app.listen(3000, () => {
  console.log('🚀 AI streaming backend running on http://localhost:3000');
});

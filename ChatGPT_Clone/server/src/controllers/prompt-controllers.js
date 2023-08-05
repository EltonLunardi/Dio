const openai = require("../config/openai");
const inputPrompt = require("../models/input-prompt");
module.exports = {
  async sendText(req, res) {
    const OpenAIApi = openai.configuration();
    const inputModel = new inputPrompt(req.body);
    try {
      const response = await OpenAIApi.createCompletion(
        openai.textCompletion(inputModel)
      );
      return res.status(200).json({
        sucess: true,
        data: response.data.choices[0].text,
      });
    } catch (error) {
      return res.status(400).json({
        sucess: false,
        error: error.response
          ? error.response
          : "Tem um problema no server manin :/",
      });
    }
  },
};

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameManager : MonoBehaviour
{
    [SerializeField] private Text scoreText;
    [SerializeField] private Text squareText;
    private int score;
    private int square = 1;

    void Start()
    {
        scoreText.text = $"{score}";
        squareText.text = $"x{square}";
    }

    void FixedUpdate()
    {
        score += Mathf.Clamp(square, 1, 20);

        ScoreUpdate();
        SquareUpdate();
    }

    void ScoreUpdate() => scoreText.text = $"{score}";

    void SquareUpdate() => squareText.text = $"x{square = Mathf.Clamp(square, 1, 20)}";
}
